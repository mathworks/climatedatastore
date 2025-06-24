
classdef cdsapi_Result < handle
    
% Copyright 2022-2025 The MathWorks, Inc.
    
    properties(GetAccess = public, SetAccess = private)
        request_id string = [];
        state string = [];
        location string = [];
        errormessage string = [];
        errorreason string = [];
    end

    properties(Access = private)
        pythonObject
    end
    
    methods
        function obj = cdsapi_Result(pythonObject)
            obj.pythonObject = pythonObject;
            obj.updateProperties;
        end
        
        function update(obj)
            obj.pythonObject.update;
            obj.updateProperties;
        end
        
        function filename = download(obj)
            filename = string(obj.pythonObject.download());
        end
    end

    methods(Access = private)
        function updateProperties(obj)
            obj.state = string(obj.pythonObject.status);
            obj.request_id = string(obj.pythonObject.request_id);
            switch obj.state
                case "successful"
                    obj.location = obj.pythonObject.url;
                case "failed"
                    error("climateDataStore:error", 'CDS API error, visit <a href="https://cds.climate.copernicus.eu/requests">https://cds.climate.copernicus.eu/requests</a> for more info')
                case "accepted"
                    % No action required
                case "running"
                    % No action required
                otherwise
                    error("climateDataStore:unexpectedState", "CDS API result unexpected state: %s", obj.state)
            end
        end
    end
end

