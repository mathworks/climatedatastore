classdef smokeTest < matlab.unittest.TestCase
% General purpose test that runs quickly to exercise high percentage of toolbox for use in version testing

% Copyright 2022 The MathWorks, Inc.

    methods(TestClassSetup)
        % Shared setup for the entire test class
    end
    
    methods(TestMethodSetup)
        % Setup for each test
    end
    
    methods(Test)
      
        function basicDataRequest(testCase)
            datasetName ="satellite-sea-ice-thickness";
            datasetOptions.version = "1_0";
            datasetOptions.variable = "all";
            datasetOptions.satellite = "cryosat_2";
            datasetOptions.cdr_type = ["cdr","icdr"]; 
            datasetOptions.year = ["2021"]; 
            datasetOptions.month = "03";
            [downloadedFilePaths,citation] = climateDataStoreDownload(datasetName,datasetOptions);            
            [filepath,name,ext] =  fileparts(downloadedFilePaths(1));
            verifyEqual(testCase, 7,exist(filepath,"dir"))
            verifyTrue(testCase, contains(filepath, datasetName))
            verifyEqual(testCase, 2,exist(fullfile(filepath, name + ext), "file"))
            verifyEqual(testCase, ".nc", ext)
            verifyEqual(testCase, "Generated using Copernicus Climate Change Service information " + string(datetime("now","Format","yyyy")), citation)
            rmdir(filepath,"s")
        end
    end
    
end