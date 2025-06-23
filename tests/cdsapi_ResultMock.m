classdef cdsapi_ResultMock < handle
% Copyright 2022-2025 The MathWorks, Inc.

    properties(GetAccess = public, SetAccess = private)
        request_id string = [];
        state string = [];
        location string = [];
        errormessage string = [];
        errorreason string = [];
    end

    properties(Access = private)
        datasetName
        datasetOptions
        options
        FilenameForDownload
        WaitUntil
    end
    
    methods
        function obj = cdsapi_ResultMock(datasetName,datasetOptions,options)
            obj.datasetName = datasetName;
            obj.datasetOptions = datasetOptions;
            obj.options = options;

            obj.request_id = "ABC123";
            
            switch datasetName
                case "satellite-sea-ice-thickness"
                    % for sea ice thickness, respond immediately, and download the zip file, unless there's an intentional invalid parameter
                    switch datasetOptions.satellite
                        case "invalidsat"
                             error("MATLAB:Python:PyException","invalid request\nRequest has not produced a valid combination of values, please check your selection.");
                        case "nocredentials"
                            error("climateDataStore:needCredentialFile","You must create a credential file.  Visit https://cds.climate.copernicus.eu/api-how-to for more info.")
                        otherwise
                            obj.replyComplete("satellite-sea-ice-thickness.zip");
                    end
                case "satellite-fire-burned-area"
                    error("MATLAB:Python:PyException","required licences not accepted\nNot all the required licences have been accepted");
                case "insitu-observations-surface-land"
                    obj.replyComplete("insitu-observations-surface-land.zip");
                case "reanalysis-era5-pressure-levels"
                    % for reanalysis-era5-pressure-levels, wait 2 seconds, and then give a .grib file
                    obj.replyQueued("reanalysis-era5-pressure-levels.grib",2);
                case "generate-python-error"
                    % for generate-python-error, give a python error with an message that's not a known one
                    error("MATLAB:Python:PyException","some other message");
                case "generate-error-at-request"
                    % for generate-error-at-request, give a non-python error
                    error("MATLAB:UndefinedFunction","Unrecognized function or variable");
                case "generate-error-type1-after-request"
                    % for generate-error-after-request, fail after half a second with a non-python error
                        obj.replyQueued("fail1",.5);
                case "generate-error-type2-after-request"
                    % for generate-error-after-request, fail after half a second with a non-python error
                        obj.replyQueued("fail2",.5);
                case "external-cancel"
                    % for external-cancel, Have the object delete itself
                        obj.replyQueued("cancel",.5);
                otherwise
                    error("MATLAB:Python:PyException","process not found");
            end

        end
        
        function update(obj)
            if obj.state == "accepted" && datetime("now") > obj.WaitUntil
                switch obj.FilenameForDownload 
                    case "fail1"
                        replyFailed(obj,"climateDataStore:UnknownError","Simulated error after request")
                    case "fail2"
                        error("climateDataStore:UnknownError","Simulated error after request")
                    case "cancel"
                        error("climateDataStore:notfoundmessage","HTTPError: 404")
                    otherwise
                        replyComplete(obj,obj.FilenameForDownload);
                end
            end
        end
        
        function filename = download(obj,~)
            if obj.state ~= "successful"
                error("climatedatastore:wrongstate","wrongstate")
            end
            [testDirectory] = fileparts(mfilename('fullpath'));
            mockFile = fullfile(testDirectory,"mockdata",obj.FilenameForDownload);
            destinationFile = fullfile(pwd,obj.FilenameForDownload);
            copyfile(mockFile,pwd);
            filename = destinationFile;
        end
    end

    methods(Access = private)
        function replyComplete(obj,filenameForDownload)
            obj.state = "successful";
            obj.location = "https://" + filenameForDownload;
            obj.FilenameForDownload = filenameForDownload;
        end

        function replyQueued(obj,filenameForDownload,waitFor)
            obj.state = "accepted";
            obj.FilenameForDownload = filenameForDownload;
            obj.WaitUntil = datetime("now") + seconds(waitFor);
        end

        function replyFailed(obj,errormessage,errorreason)
            obj.state = "failed";
            obj.errormessage = errormessage;
            obj.errorreason = errorreason;
        end
    end
end

