classdef climateDataStoreDownloadFuture < handle
%climateDataStoreDownloadFuture Represents a queued request with the Copernicus Climate Data Store. (https://cds.climate.copernicus.eu/cdsapp)
%
% climateDataStoreDownloadFuture objects are not created directly.  Use climateDataStoreDownloadAsync 
%
% climateDataStoreDownloadAsync returns this object you can use to query the state of your request, and cancel the request.  Note that if you delete
% this object, or allow it to be cleared, your request with CDS will be cancelled.  Note that this is not a true Future: the operation does not take
% place on a seperate thread. Download of files will not take place until you interact with the object, either through checking Status or using wait().
% 
% You can check on the status of your request by visiting https://cds.climate.copernicus.eu/cdsapp#!/yourrequests.
%
% The methods and properties are modeled on the Future object in MATLAB
%
% climateDataStoreDownloadFuture methods:
%       cancel       - Cancel a queued, or running request
%       wait         - Wait for request to complete, and download results
% 
%    climateDataStoreDownloadFuture properties:
%       CreateDateTime     - Date and time at which this request was created
%       Error              - Request error information (filled in if State is "failed")
%       FinishDateTime     - Date and time at which this request finished running
%       Function           - Function to evaluate
%       ID                 - CDS query identifier
%       InputArguments     - Input arguments to function
%       NumOutputArguments - Number of arguments returned by function (filled in if State is "completed")
%       OutputArguments    - Output arguments from running Function (filled in if State is "completed")
%       RunningDuration    - The duration of time the request has been running for, if it has started
%       StartDateTime      - Date and time at which this future request running
%       State              - Current state of request from CDS (completed|queued|running|failed)
%
% See Also: climateDataStoreDownloadAsync, Future

% Copyright 2022 The MathWorks, Inc.
    
    properties (SetAccess=private)
        % Date and time at which this request was created
        CreateDateTime (1,1) datetime = datetime('now');

        % Request error information (filled in if State is "failed")
        Error MException = MException.empty();

        % Date and time at which this request finished running
        FinishDateTime datetime = datetime.empty();

        % Function to evaluate
        Function function_handle

        % CDS query identifier
        ID string = ""

        % Input arguments to function
        InputArguments cell

        % Number of arguments returned by function.  Filled in if State is "completed"
        NumOutputArguments (1,1) double = 0;

        % Output arguments from running Function filled in if State is "completed". filepaths is in element 1, citation in element 2.
        OutputArguments cell = {};

        % The duration of time the request has been running for, if it has started
        RunningDuration duration = duration.empty();

        % Date and time at which this future request running
        StartDateTime datetime = datetime.empty();

        % Current state of request from CDS (completed|queued|running|failed)
        State (1,1) string = "unavailable"
    end
    
    methods
        function obj = climateDataStoreDownloadFuture(datasetName, datasetOptions,options)
            arguments
                datasetName (1,1) string
                datasetOptions (1,1) struct
                options (1,1) struct;
            end
        
            % Get the name of the calling function
            frames = dbstack(1);
            obj.Function = str2func(frames(1).name);
            obj.InputArguments = {datasetName,datasetOptions};
            obj.ExpandZip = ~options.DontExpandZIP;

            % Convert the structure from strings to char and cellstr.
            datasetOptions = climateDataStoreDownloadFuture.makeStringsChars(datasetOptions);

            % Delegate to a factory so that mocking infrastructure doesn't impact code coverage
            obj.CdsapiClient = cdsapi_Factory.getCdsapi(options);
            
            obj.StartDateTime = datetime('now');
            try
                obj.CdsResult = obj.CdsapiClient.retrieve(datasetName,datasetOptions);
            catch e
                obj.FinishDateTime = datetime('now');
                if e.identifier == "MATLAB:Python:PyException"
                    if contains(string(e.message),"name not found")
                        obj.Error = MException("climateDataStore:NameNotFound","Data Set Name not found");
                    elseif contains(string(e.message),"not agreed to the required terms and conditions")
                        obj.Error = MException("climateDataStore:agreeToTC",string(e.message));
                    else
                        obj.Error = e;
                    end
                else
                    obj.Error = e;
                end
                obj.StateInternal = "failed";
                return
            end
            obj.ID = obj.CdsResult.request_id;
            obj.update();
        end
        
        function cancel(obj)
            % Cancel a queued, or running request
            %
            % cancel(F) cancels the request associated with F.

            if isempty(obj.CdsResult)
                return
            end

            obj.update();
            if obj.StateInternal ~= "completed" && obj.StateInternal ~= "failed"
                % Deleting the python result object will cancel the request with CDS.
                obj.CdsResult = [];
                obj.FinishDateTime = datetime('now');
                obj.Error = MException("climateDataStore:RequestCancelled","The request with ID ''%s'' was cancelled.",obj.ID);
                obj.StateInternal = "failed";
            end
        end
        
        function wait(obj,timeout)
            % Wait for request to complete, and download results
            %
            % wait(F) waits for the request associated with F to complete or fail, blocking MATLAB execution.  On a successful completion, the
            % results are downloaded, and OutputArguments property is updated with the path and citation.  On failure, the Error property is updated with error
            % information.
            % wait(..., timeToWait) limits the time to wait to timeToWait seconds.

            arguments
                obj
                timeout (1,1) double {mustBePositive} = Inf;
            end
            
            if isempty(obj.CdsResult)
                return
            end 

            obj.update();
            waitTimer = tic;
            while obj.StateInternal ~= "completed" && obj.StateInternal ~= "failed" && toc(waitTimer) < timeout
                drawnow();
                pause(.1);
                obj.update();
            end
            if obj.StateInternal ~= "completed" && obj.StateInternal ~= "failed"
                error("climateDataStore:timeout","The wait operation timed out.")
            end
        end
    end

    % ======================== PROPERTY SET/GET METHODS ======================== 
    methods
        function result = get.OutputArguments(obj)
            obj.update();
            result = obj.OutputArguments; 
        end

        function result = get.RunningDuration(obj)
            obj.update();
            if isempty(obj.FinishDateTime)
                % If it's still running, calculate elaspsed time
                result = datetime('now') - obj.StartDateTime;
            else
                % If it's done, return the time it took
                result = obj.FinishDateTime - obj.StartDateTime;
            end
        end

        function result = get.State(obj)
            obj.update()
            result = obj.StateInternal;
        end
    end

    % ======================== INTERNAL PROPERTIES AND METHODS ======================== 
    properties (Access=private)
        CdsapiClient
        CdsResult
        areResultsUpdated logical = false;
        ExpandZip logical = true;
        StateInternal
    end

    methods (Access=private)
        function update(obj)
            if isempty(obj.CdsResult)
                return;
            end

            try
                obj.CdsResult.update;
            catch e
                obj.FinishDateTime = datetime('now');
                if contains(e.message,"HTTPError: 404")
                    obj.Error = MException("climateDataStore:RequestDeleted","The request with ID ''%s'' was deleted.",obj.ID);
                else
                    obj.Error = e;
                end
                obj.StateInternal = "failed";
                return
            end
            obj.StateInternal = obj.CdsResult.state;
            if obj.StateInternal == "completed"
                obj.getResultsIfAvailable();
            elseif obj.StateInternal == "failed"
                obj.getErrorInfo();
            end
        end

        function getResultsIfAvailable(obj)
            if isempty(obj.CdsResult) || obj.areResultsUpdated
                return
            end
               
            if obj.CdsResult.state == "completed"
                obj.FinishDateTime = datetime('now');
                [~,filenameOnCDS,extOnCDS] = fileparts(obj.CdsResult.location);
                filenameOnCDS = filenameOnCDS + extOnCDS;
                localFilename = obj.InputArguments{1} + "-" + string(obj.FinishDateTime,"yyyyMMddhhmmss");
                downloadedFileName = string(obj.CdsResult.download(filenameOnCDS));

                % Generate the citation
                citation = "Generated using Copernicus Climate Change Service information " + string(datetime('now','Format','y'));

                % check if file exists
                if exist(downloadedFileName,"file") ~= 2
                    %error
                end

                if lower(extOnCDS) == ".zip" && obj.ExpandZip
                    % Expand the ZIP in a directory
                    filePaths = string(unzip(downloadedFileName,localFilename)');
                    obj.OutputArguments = {filePaths,citation};
                
                    % Delete the temporary ZIP file
                    delete(downloadedFileName);
                else
                    % Rename the file to something better
                    localFilename = localFilename + extOnCDS;
                    movefile(downloadedFileName,localFilename);
                    obj.OutputArguments = {localFilename,citation};
                end
                obj.NumOutputArguments = 2;
                obj.areResultsUpdated = true;
            end
        end        

        function getErrorInfo(obj)
            if isempty(obj.CdsResult) || obj.areResultsUpdated
                return
            end
               
            obj.FinishDateTime = datetime('now');
            if contains(obj.CdsResult.errormessage ,"not valid")
                obj.Error = MException("climateDataStore:InvalidRequest",obj.CdsResult.errorreason);
            else
                obj.Error = MException("climateDataStore:UnknownError",obj.CdsResult.errorreason);
            end
            obj.StateInternal = "failed";
            obj.areResultsUpdated = true;
            return
        end
    end

    methods (Access=private, Static)
        function theStruct = makeStringsChars(theStruct)
            fields = string(fieldnames(theStruct));
            for iField = 1:numel(fields)
                if isstring(theStruct.(fields(iField)))
                    if isscalar(theStruct.(fields(iField)))
                        % Convert scalar strings to char
                        theStruct.(fields(iField)) = char(theStruct.(fields(iField)));
                    else
                        % Convert string arrays to cell array of chars
                        theStruct.(fields(iField)) = cellstr(theStruct.(fields(iField)));
                    end
                end
            end
        end
    end
end

