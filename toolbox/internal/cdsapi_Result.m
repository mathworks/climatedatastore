
classdef cdsapi_Result < handle
    
% Copyright 2022-2025 The MathWorks, Inc.
    
    properties(GetAccess = public, SetAccess = private)
        request_id string = "";
        state string = "";
        location string = "";
        errormessage string = "";
        errorreason string = "";
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
            newState = string(obj.pythonObject.status);
            if newState == obj.state
                return
            end
            if obj.request_id == ""
                obj.request_id = string(obj.pythonObject.request_id);
            end
            switch newState
                case "successful"
                    obj.location = obj.pythonObject.url;
                    if obj.state == "failed"
                        error("climateDataStore:badStateTransition","State tried to go from '%s' to '%s'", obj.state, newState)
                    end
                    obj.state = newState;
                case "failed"
                    if obj.state == "successful"
                        error("climateDataStore:badStateTransition","State tried to go from '%s' to '%s'", obj.state, newState)
                    end
                    obj.state = newState;
                    error("climateDataStore:error", 'CDS API error, visit <a href="https://cds.climate.copernicus.eu/requests">https://cds.climate.copernicus.eu/requests</a> for more info')
                case "accepted"
                    if obj.state == "failed"
                        error("climateDataStore:badStateTransition","State tried to go from '%s' to '%s'", obj.state, newState)
                    end
                    if obj.state == "running" || obj.state == "successful"
                        % Sometimes the CDS object transitions backwards from 'running' or 'successful' to 'accepted' .  Ignore it
                        return
                    end
                    obj.state = newState;
                case "running"
                    if obj.state == "successful" || obj.state == "failed"
                        error("climateDataStore:badStateTransition","State tried to go from '%s' to '%s'", obj.state, newState)
                    end
                    obj.state = newState;
                otherwise
                    error("climateDataStore:unexpectedState", "CDS API result unexpected state: %s", obj.state)
            end
        end
    end
end

