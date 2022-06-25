classdef cdsapi_ResultMock < handle
    
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
                            obj.replyFailed("not valid","not valid")
                        case "needtoagree"
                            error("MATLAB:Python:PyException","not agreed to the required terms and conditions");
                        case "nocredentials"
                            error("climateDataStore:needCredentialFile","You must create a credential file.  Visit https://cds.climate.copernicus.eu/api-how-to for more info.")
                        otherwise
                            obj.replyComplete("satellite-sea-ice-thickness.zip");
                    end
                case "insitu-observations-surface-land"
                    obj.replyComplete("insitu-observations-surface-land.zip");
                case "cems-glofas-reforecast"
                    % for cems-glofas-reforecast, wait 1 second, and then give a .grib file
                    obj.replyQueued("cems-glofas-reforecast.grib",1);
                otherwise
                    error("MATLAB:Python:PyException","name not found");
            end

        end
        
        function update(obj)
            if obj.state == "queued" && datetime("now") > obj.WaitUntil
                replyComplete(obj,obj.FilenameForDownload);
            end
        end
        
        function filename = download(obj,~)
            if obj.state ~= "completed"
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
            obj.state = "completed";
            obj.location = "https://" + filenameForDownload;
            obj.FilenameForDownload = filenameForDownload;
        end

        function replyQueued(obj,filenameForDownload,waitFor)
            obj.state = "queued";
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

