function F = climateDataStoreDownloadAsync(datasetName,datasetOptions,options)
%climateDataStoreDownload Queue a data request from Copernicus Climate Data Store
% Queue a data set request with the Copernicus Climate Data Store. (https://cds.climate.copernicus.eu/cdsapp)
%
% Find your dataset at Climate Data Store and click on the "download data" tab.  Make your selections for the subset of data you want.  Click "show
% API request" at the bottom.
%
% F = climateDataStoreDownloadAsync(datasetName,datasetOptions) queues a request for the data set with the name datasetName, and will also be used
% as the name of the directory or file downloaded files, with a date/time stamp added.  datasetOptions is a MATLAB structure matching the python
% structure shown when you choose "Show API request".  F is an object you can use to query the state of your request, and cancel the request.  Note
% that if you delete F, or allow it to be cleared, your request with CDS will be cancelled.  Note that the operation does not take place on a
% seperate thread -- download of files will not take place until you interact with F, either through checking Status or using wait().
%
% climateDataStoreDownloadAsync(...,DontExpandZIP=true Results that are ZIP files are not automatically expanded.
% climateDataStoreDownloadAsync(...,DontPromptForCredentials=true If no credentials are present, don't request them (intended for tests)
% 
% Downloading the files can take some time, depending on how large they are (I've had it take 30 minutes!).  You can check on the status of your
% request by visiting https://cds.climate.copernicus.eu/cdsapp#!/yourrequests.  For simple/quick requests, you may want to consider using
% climateDataStoreDownload, which is easier to use, but blocks MATLAB.
%
% Note that many requests return immediately.  You should check Status property right away.  Results may be available.
%
% Notes:
% You must have:
%   * python 3.8 installed (https://www.python.org/ftp/python/3.8.10/python-3.8.10-amd64.exe)
%   * the cdsapi python package (pip3 install cdsapi)
%   * Your credentials need to be in a .cdsapirc file in your user directory. See https://cds.climate.copernicus.eu/api-how-to for more info
%   * This function relies on the Python API to access the Copernicus Climate Data Store (CDS) (https://github.com/ecmwf/cdsapi) by the European
%     Centre for Medium-Range Weather Forecasts (ECMWF)
%
% Example: ERA5 hourly data on pressure levels (https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-pressure-levels)
%     datasetName ="reanalysis-era5-pressure-levels";
%     datasetOptions.product_type = "reanalysis";
%     datasetOptions.format = "grib";
%     datasetOptions.year = "2020";
%     datasetOptions.month = "01";
%     datasetOptions.day = "01";
%     datasetOptions.pressure_level = "1";
%     datasetOptions.variable = "divergence";
%     datasetOptions.time = "06:00";
%     F = climateDataStoreDownloadAsync(datasetName, datasetOptions);         
%     % Run whatever MATLAB code you want in here.
%     F.wait();
%     if F.state == "completed"
%       downloadedFilePaths = OutputArguments{1};
%       citation = OutputArguments{2};
%     end
%
% See Also: climateDataStoreDownload, climateDataStoreDownloadFuture

% Copyright 2022 The MathWorks, Inc.

    arguments
        datasetName (1,1) string
        datasetOptions (1,1) struct
        options.DontExpandZIP (1,1) logical = false;
        options.DontPromptForCredentials (1,1) logical = false;
        options.UseMocks (1,1) logical = false;
    end

    F = climateDataStoreDownloadFuture(datasetName,datasetOptions, options);
end
