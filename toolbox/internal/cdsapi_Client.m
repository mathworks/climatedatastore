classdef cdsapi_Client < handle
    %CDSAPI_CLIENT Wrap around the py.cdsapi.Client so that we can mock it for testing
    
    properties(Access = private)
        pythonObject
    end
    
    methods
        function obj = cdsapi_Client(options)
            arguments
                options (1,1) struct;
            end
            % Diagnostics
            setupPythonIfNeeded();
            setupCDSAPIIfNeeded(~options.DontPromptForCredentials);
            
            obj.pythonObject = py.cdsapi.Client();
            % Don't show the progress information
            obj.pythonObject.quiet = true;
            obj.pythonObject.progress = false;
            obj.pythonObject.wait_until_complete = false;
        end
        
        function result = retrieve(obj, datasetName, datasetOptions)
            result = cdsapi_Result(obj.pythonObject.retrieve(datasetName,datasetOptions));
        end
    end
end

