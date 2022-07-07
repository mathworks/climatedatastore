function cdsapiClient = cdsapi_Factory(options)
    if options.UseMocks
        cdsapiClient = cdsapi_ClientMock(options);
    else
        cdsapiClient = cdsapi_Client(options);
    end
end

