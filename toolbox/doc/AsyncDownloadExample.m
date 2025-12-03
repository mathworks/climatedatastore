%% Async Download Example
% This script demonstrates how to use the `climateDataStoreDownloadAsync` function
% to download data from the Copernicus Climate Data Store (CDS) without blocking
% MATLAB execution.

%% Define Dataset and Options
% We will request ERA5 hourly data on pressure levels.
datasetName = "reanalysis-era5-pressure-levels";
datasetOptions = struct();
datasetOptions.product_type = "reanalysis";
datasetOptions.format = "grib";
datasetOptions.variable = "temperature";
datasetOptions.pressure_level = "1000";
datasetOptions.year = "2022";
datasetOptions.month = "01";
datasetOptions.day = "01";
datasetOptions.time = "12:00";

%% Start Async Download
% The `climateDataStoreDownloadAsync` function returns a future-like object.
% This allows you to continue working while the request is processed on the CDS servers.
fprintf('Starting download request...\n');
F = climateDataStoreDownloadAsync(datasetName, datasetOptions);

%% Do other work
% While the request is queued and running on CDS, you can perform other tasks.
% For demonstration, we will just pause and check the status periodically.
fprintf('Request sent. You can do other work now.\n');

% You can check the state of the request
fprintf('Current state: %s\n', F.State);

%% Wait for completion
% Use the `wait` method to block until the download is complete.
% You can also check `F.State` in a loop if you want to update a UI or progress bar.
fprintf('Waiting for download to complete...\n');
wait(F);

%% Retrieve Results
if F.State == "successful"
    % The downloaded file paths and citation are in OutputArguments
    downloadedFilePaths = F.OutputArguments{1};
    citation = F.OutputArguments{2};
    
    fprintf('Download successful!\n');
    fprintf('Files downloaded to:\n');
    disp(downloadedFilePaths);
    fprintf('Citation:\n%s\n', citation);
    
    % Example of reading the data (if GRIB support is available or if it was netcdf)
    % For this example, we just list the file details.
    for i = 1:numel(downloadedFilePaths)
        dir(downloadedFilePaths(i));
    end
else
    fprintf('Download failed with error: %s\n', F.Error.message);
end
