classdef cdsapi_ClientMock < handle
    %CDSAPI_CLIENT Wrap around the py.cdsapi.Client so that we can mock it for testing
    
    properties(Access = private)
        options
    end
    
    methods
        function obj = cdsapi_ClientMock(options)
            arguments
                options (1,1) struct;
            end
            obj.options = options;
        end
        
        function result = retrieve(obj, datasetName, datasetOptions)
            result = cdsapi_ResultMock(datasetName,datasetOptions,obj.options);
        end
    end
end

