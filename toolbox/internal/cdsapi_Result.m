classdef cdsapi_Result < handle
    
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
        
        function filename = download(obj,url)
            filename = string(obj.pythonObject.download(url));
        end
    end

    methods(Access = private)
        function updateProperties(obj)
            reply = obj.pythonObject.reply;
            obj.state = string(reply{'state'});
            obj.request_id = string(reply{'request_id'});
            switch obj.state
                case "completed"
                    obj.location = string(reply{'location'});
                case "failed"
                    error = reply{'error'};
                    obj.errormessage = string(error{'message'});
                    obj.errorreason = string(error{'reason'});
            end
        end
    end
end

