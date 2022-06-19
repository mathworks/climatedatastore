classdef longTest < matlab.unittest.TestCase
    % Tests that can take a long time to run, if CDS is backed up
    
    methods(TestClassSetup)
        % Shared setup for the entire test class
    end
    
    methods(TestMethodSetup)
        % Setup for each test
    end
    
    methods(Test)
        % Test methods
        
        % Can take 25 minutes!
        function ERA5FileTest(testCase)
            datasetName ="reanalysis-era5-pressure-levels";
            datasetOptions.product_type = "reanalysis";
            datasetOptions.format = "grib";
            datasetOptions.year = "2020";
            datasetOptions.month = "01";
            datasetOptions.day = "01";
            datasetOptions.pressure_level = "1";
            datasetOptions.variable = "divergence";
            datasetOptions.time = "06:00";
            [downloadedFilePaths,citation] = climateDataStoreDownload(datasetName,datasetOptions);
            verifyTrue(testCase, exist(downloadedFilePaths,"file") == 2)
            [~,~,ext] = fileparts(downloadedFilePaths);
            verifyEqual(testCase, ext,".grib")
            verifyEqual(testCase, citation, "Generated using Copernicus Climate Change Service information " + string(datetime('today'),'yyyy'))

            delete(downloadedFilePaths)
        end
        
        % Can take 25 minutes!
        function ERA5FileAsyncTest(testCase)
            datasetName ="reanalysis-era5-pressure-levels";
            datasetOptions.product_type = "reanalysis";
            datasetOptions.format = "grib";
            datasetOptions.year = "2020";
            datasetOptions.month = "01";
            datasetOptions.day = "01";
            datasetOptions.pressure_level = "1";
            datasetOptions.variable = "divergence";
            datasetOptions.time = "06:00";

            cdsFuture = climateDataStoreDownloadAsync(datasetName, datasetOptions);            
            cdsFuture.wait();
            verifyTrue(testCase, exist(cdsFuture.OutputArguments{1},"file") == 2)
            [~,~,ext] = fileparts(cdsFuture.OutputArguments{1});
            verifyEqual(testCase, ext,".grib")
            verifyEqual(testCase, cdsFuture.OutputArguments{2}, "Generated using Copernicus Climate Change Service information " + string(datetime('today'),'yyyy'))

            verifyEqual(testCase, cdsFuture.State,"completed")
            delete(cdsFuture.OutputArguments{1})
        end
    end
    
end