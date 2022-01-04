function allFileData = readSatelliteSeaIceThickness(filenames)
    % Function to read and reformat ice data.  Reshape the arrays into a timetable and remove empty rows
    arguments
        filenames string {mustBeFile};
    end
    
    allFileData = timetable();
    for iFileName = 1:numel(filenames)
        time = datetime(ncread(filenames(iFileName),"time"),"ConvertFrom","posixtime");
        lat = ncread(filenames(iFileName),"lat");
        lat = reshape(lat,[numel(lat) 1]);
        lon = ncread(filenames(iFileName),"lon");
        lon = reshape(lon,[numel(lon) 1]);
        thickness = ncread(filenames(iFileName),'sea_ice_thickness');
        thickness = reshape(thickness,[numel(thickness) 1]);
        time = repmat(time,[numel(lat) 1]);
        thisFileData = timetable(time,lat,lon,thickness);
        thisFileData = rmmissing(thisFileData);
        allFileData = [allFileData; thisFileData]; %#ok<AGROW>
    end
end