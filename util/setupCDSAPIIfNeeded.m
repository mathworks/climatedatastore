function setupCDSAPIIfNeeded
%SETUPCDSAPIIFNEEDED Install CSAPI module if it is not installed

% Copyright 2021 The MathWorks, Inc.

    pythonInfo = pyenv;
    
    if pythonInfo.Version == ""
        % Python not set up
        error("setupCDSAPI:pythonNotInstalled","Python not installed.")
    end

    % Call PIP to see if cdsapi is installed
    [result, ~]  = system(fullfile(pythonInfo.Home,"Scripts","pip3")+" show cdsapi");
    if result ~= 0
        % it's not installed
        [result, ~]  = system(fullfile(pythonInfo.Home,"Scripts","pip3")+" install cdsapi");
        if result ~= 0
            error("setupCDSAPI:unableToInstall","Could not use PIP3 to install CDSAPI")
        end
    end
    
    % Check to make sure that the CDSAPI credential file exists
    cdsCredentialPath = fullfile(getUserDirectory(),".cdsapirc");
    
    if ~exist(cdsCredentialPath,'file')
        % Prompt user for credentials
        prompt = {'url','key'};
        dlgtitle = 'Enter your CDS credentials (visit https://cds.climate.copernicus.eu/api-how-to)';
        dims = [1 35];
        definput = {'https://cds.climate.copernicus.eu/api/v2','<your key here>'};
        answer = inputdlg(prompt,dlgtitle,dims,definput);
        
        if isempty(answer)
            error("setupCDSAPI:needCredentialFile","You must create a credential file.  visit https://cds.climate.copernicus.eu/api-how-to for more info.")
        end
        
        url = string(answer{1});
        key = string(answer{2});
        
        % create the credentials file
        fileContents = "url: " + url + newline + "key: " + key + newline;
        [fid,errmsg] = fopen(cdsCredentialPath,"wt","n","UTF-8");
        if fid == -1
            error("setupCDSAPI:cannotCreateCredentials","Cannot create a credential file (%s).  %s", cdsCredentialPath, errmsg)
        end
        fwrite(fid,fileContents);
        fclose(fid);
    end
end

